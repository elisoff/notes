class Api::NotesController < ApplicationController
  respond_to :json
  
  def index
    notes = Note.all
    
    respond_with notes
  end
  
  def show
    note = get_note(params.require(:id))

    respond_with note
  end
  
  def create
    request_fields = request.request_parameters
    
    if request_fields[:prioriry_id]
      priority = Priority.find(request_fields[:priority_id])
    end
    
    errors = validate_fields(request_fields)
    
    if errors.length > 0
      result = { :errors => { :fields =>  errors } }
    else 
      user = User.find(session[:user_id])

      note = Note.create(name: request_fields[:name], text: request_fields[:text],
                         done: request_fields[:done], datetime: request_fields[:datetime],
                         user: user, priority: priority)
                       
      result = note
    end
    
    respond_with result, location: ""
  end
  
  def update
    request_fields = request.request_parameters
    
    field_errors = validate_fields(request_fields)
    
    if field_errors.length > 0
      errors = { :errors => { :fields => field_errors } }
    else
      note = get_note(params.require(:id))

      if !note[:errors]
        update_hash = request_fields

      updated_note = note.update(update_hash)

      if updated_note
        result = { :success => true }
        if !updated_note
          errors = { :errors => updated_note}
        end
      else
        errors = { :errors => { :msg => "No note found!" } }
      end
    end
    
    if errors
    else
    end
  end
  
  def destroy
    
    rescue ActiveRecord::RecordNotFound 
      result = { :success => false, :errors => "Note not found" }
    
    end
    end
    
  end
  
  private
  def validate_fields(fields)
    errors = {}
    if fields[:datetime]
      Time.zone = "Brasilia" # todo: implement timezone
      now = Time.zone.now
      parsed_datetime = Time.zone.parse(fields[:datetime])
      if parsed_datetime < now
        errors[:datetime] = "The date must be in the future"
      end
    end
    errors
  end
  
  private
  def get_note(id)
    note = Note.find(id)
    
    rescue ActiveRecord::RecordNotFound 
      
    result
  end
end

