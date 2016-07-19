class Api::SuicaHistoriesController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def create
    data = JSON.parse(request.body.read, {:symbolize_names => true})

    idm = data[:idm].upcase
    system = data[:system]

    unless data.key?(:suica_history)
      render status: :bad_request, json: {
        message: 'suica_history is required'
      }
      return
    end

    if request.headers['authorization'] == nil
      render status: :unauthorized, json: {
        message: 'authorization token is required'
      }
      return
    end

    auth_token = request.headers['authorization'].sub(/^Bearer\s+/, '')
    unless CardReader.exists?(token: auth_token)
      render status: :unauthorized, json: {
        message: 'authorization token is invalid'
      }
      return
    end

    saved_new_history = false

    ActiveRecord::Base.transaction do
      card = Card.find_by(idm: idm)
      unless card
        card = Card.new(
          idm: idm,
          system: system,
          system_code: data[:system_code]
        )
        card.save!
      end

      data[:suica_history].each { |h|
        serial_number = h[:serial_number]
        date = h[:date]

        if SuicaHistory.exists?(
          card_id: card.id,
          serial_number: serial_number,
          date: date
        )
          next
        end

        history = SuicaHistory.new(
          card_id: card.id,
          serial_number: serial_number,
          data_type: h[:data_type],
          terminal_code: h[:terminal],
          processing_code: h[:processing],
          date: date,
          balance: h[:balance],
          region: h[:region],
          block: h[:block]
        )
        history.determine_expense!
        if h.key?(:station)
          station = h[:station]
          history.entered_line_code = station[:entered_line_code]
          history.entered_station_code = station[:entered_station_code]
          history.exited_line_code = station[:exited_line_code]
          history.exited_station_code = station[:exited_station_code]
        end
        history.save!
        saved_new_history = true
      }
    end

    if saved_new_history
      begin
        card = Card.find_by(idm: idm)
        holder_name = card.holder ? card.holder.name : '所有者不明'
        card_name = card.name.empty? ? card.idm : card.name
        last_history = SuicaHistory.find_last_history(card.id)

        notifier = ::Slack::Notifier.new(Rails.application.secrets.slack_webhook_url)
        notifier.ping '', attachments: [
          {
            text: "*#{holder_name}* さんの *#{card_name}* を読み取りました。",
            color: "good",
            fields: [
              {title: "最終履歴", value: l(last_history.date, format: :long), short: true},
              {title: "残高", value: view_context.number_to_currency(last_history.balance), short: true},
            ],
            mrkdwn_in: ['text'],
          }
        ]
      rescue => e
        p e.message
      end
    end

    render status: :ok, json: {
      message: 'ok'
    }
  end
end
