class Api::NotesController < ApplicationController
  respond_to :json
  
  def index
    notes = Note.all
    
    result = { :success => true, :rows => notes }
    
    respond_with result
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
      result = { :success => false, :errors => errors }
    else 
      user = User.find(session[:user_id])

      note = Note.create(name: request_fields[:name], text: request_fields[:text],
                         done: request_fields[:done], datetime: request_fields[:datetime],
                         user: user, priority: priority)
                       
      result = format_result(note)
    end
    
    respond_with result, location: ""
  end
  
  def update
    request_fields = request.request_parameters
    
    note = get_note(params.require(:id))
      
    if note[:success] != false
      update_hash = request_fields

      if request_fields[:prioriry_id]
        priority = Priority.find(request_fields[:priority_id])
        update_hash[:priority] = priority
      end

      updated_note = note.update(update_hash)

      if updated_note
        result = { :success => true }
      else
        result = { :success => false, :errors => updated_note}
      end
    else
      result = note
    end
   
    respond_with "", json: result
  end
  
  def destroy
    note_id = params.require(:id)
    
    deleted_note = Note.destroy(note_id)
    
    rescue ActiveRecord::RecordNotFound 
      result = { :success => false, :errors => "Note not found" }
    
    if deleted_note
      result = { :success => true }
    else 
      result = { :success => false, :errors => deleted_note }
    end
    
    respond_with "", json: result
  end
  
  private
  def format_result(action)
    result = { :success => action.errors.count <= 0 ? true : false }
    
    if action.errors.count > 0
      result[:errors] = action.errors 
    else 
      result[:rows] = action
    end
    
    result
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
    result = format_result(note)
    
    rescue ActiveRecord::RecordNotFound 
      result = { :success => false, :errors => "Note not found" }
      
    result
  end
end

