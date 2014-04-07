class ErrorDecorator < Draper::Decorator
  delegate_all

  def account
    Rails.configuration.airbrake_account
  end

  def href
    "https://#{account}.airbrake.io/projects/#{object.project_id}/groups/#{object.id}"
  end

  # try to fit into 3-4 lines max
  def error_message
    object.error_message.truncate(180, omission: "\u2026")
  end

  def most_recent_notice_at
    object.most_recent_notice_at.iso8601
  end

  def action
    [object.controller, object.action].reject(&:blank?).join('#')
  end

  def classes
    resolved_classes +
    rails_env_classes +
    count_classes +
    most_recent_classes
  end

  # highlight prod-errors
  def rails_env_classes
    ["env-#{object.rails_env}"]
  end

  # grey out resolved
  def resolved_classes
    if object.resolved
      ["resolved"]
    else
      ["not-resolved"]
    end
  end

  # highlight errors that has occurred many times
  def count_classes
    case object.notices_count
    when 0..1    then ["count-one"]
    when 2..5    then ["count-two"]
    when 5..16   then ["count-five"]
    when 16..64  then ["count-sixteen"]
    when 64..128 then ["count-sixty-four"]
    else              ["count-very-many"]
    end
  end

  # highlight recent errors
  def most_recent_classes
    case Time.current - object.most_recent_notice_at
    when 0.seconds..5.minutes  then ["just-now"]
    when 5.minutes..30.minutes then ["more-than-5-mins"]
    when 30.minutes..3.hours   then ["more-than-30-mins"]
    when 3.hours..12.hours     then ["more-than-3-hours"]
    when 12.hours..24.hours    then ["more-than-12-hours"]
    when 24.hours..2.days      then ["more-than-1-day"]
    when 2.days..7.days        then ["more-than-2-days"]
    else                            ["more-than-a-week"]
    end
  end
end