# frozen_string_literal: true

# Present report data for the projects within the start and end dates.
class ReportView
  attr_reader :project_ids, :start_on, :end_on, :grouping, :report

  delegate :billable_amount, :billable_percentage, :billable_ratio, to: :report
  delegate :total_duration, :billable_duration, :non_billable_duration, to: :report
  delegate :entries, :entries_by_group_name, :entries_by_project_name, to: :report

  delegate :columns, :column_names, :column_methods, to: :grouping

  def self.for(kind)
    return self if kind.to_sym == :custom

    # FIXME: this isn't secure it should lookup by kind in a hash map
    "#{kind}_report_view".classify.constantize
  end

  def self.build(project_ids, grouping:, start_on: nil, end_on: nil, kind: :custom)
    klass = self.for(kind)
    return klass.current(project_ids) unless start_on && end_on

    klass.new(project_ids, start_on:, end_on:, grouping:)
  end

  def self.current(project_ids)
    raise NotImplementedError
  end

  def initialize(project_ids, start_on:, end_on:, grouping: Report::Grouping.default_name)
    @project_ids = project_ids
    @start_on    = start_on.to_date
    @end_on      = end_on.to_date
    @report      = Report.new(project_ids, date_range)
    @grouping    = @report.build_grouping(grouping)
  end

  def grouping?(grouping_name)
    @grouping.name == grouping_name
  end

  def title
    if title_prefix
      "#{title_prefix}: #{formatted_start_date} - #{formatted_end_date}"
    else
      "#{formatted_start_date} - #{formatted_end_date}"
    end
  end

  def title_prefix
    nil
  end

  def formatted_start_date
    return start_on.strftime('%d') if start_on.same_month?(end_on)
    return start_on.strftime('%d %b') if start_on.same_year?(end_on)

    start_on.strftime('%d %b %Y')
  end

  def formatted_end_date
    end_on.strftime('%d %b %Y')
  end

  def start_at
    return unless start_on

    start_on.at_beginning_of_day
  end

  def end_at
    return unless end_on

    end_on.at_end_of_day
  end

  def date_range
    start_on..end_on
  end

  def current?
    date_range.include?(Date.today)
  end

  def entry_groupings
    grouping.entries.lazy.map do |(name, entries)|
      ReportGroupingView.new(name, entries)
    end
  end

  def symmetric?
    false
  end

  def kind
    'custom'
  end
end
