class LivestreamsController < ApplicationController
#     def batch_upload
#         attendees = params[:attendees]
#         eb_event_id = params[:eb_event_id]
#
#         attendees.each do |att|
#             email = att[:email]
#             id = att[:id]
#             puts "----- att: #{email}/#{id} ----"
#             dbrec = EbAttendee.find_by("event_id = ? and user_eventbrite_id = ?", eb_event_id, id)
#
#
#             if dbrec == nil
#                 EbAttendee.create(event_id: eb_event_id, email: email, used: false, user_eventbrite_id: id)
#             else
#                 unless dbrec.used
#                     dbrec.update(event_id: eb_event_id, email: email)
#                 end
#             end
#         end
#
#         total = EbAttendee.where("event_id = ?", eb_event_id).count
#         render json: {total: total}
#         # events = Event.where("finish_time < ? AND host_user = ?", Time.now, session[:user_id]).limit(5).order("finish_time DESC")
#     end
#
#     def attendee_count
#         eb_event_id = params[:id]
#         total = EbAttendee.where("event_id = ?", eb_event_id).count
#         render json: {total: total}
#     end
end
