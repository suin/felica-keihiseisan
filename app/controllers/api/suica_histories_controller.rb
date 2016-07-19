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
          break
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
      }
    end

    render status: :ok, json: {
        message: 'ok'
    }
  end
end
