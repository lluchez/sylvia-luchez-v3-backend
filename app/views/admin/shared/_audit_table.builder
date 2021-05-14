# ugly hack to 'partialize' this in activeadmin
context.instance_eval do
  table_for resource.audits do
    column "User" do |audit|
      AdminUser.find(audit.user_id).email if audit.user_id.present?
    end

    column "Time" do |audit|
      audit.created_at.in_time_zone.strftime(LONG_DATETIME_FORMAT)
    end

    column "Audited Changes" do |audit|
      lines = []
      audit.audited_changes.each do |k,v|
        changes = audit.audited_changes[k]
        if changes.kind_of?(Array) && changes.length == 2
          lines << "Changed #{k} from #{changes.first || '[nil]'} to #{changes.last || '[nil]'}"
        end
      end
      lines.join("<br />").html_safe
    end

    column :comment
  end
end
