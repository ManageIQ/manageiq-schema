class AddLastPerfCaptureOnToContainerImages < ActiveRecord::Migration[6.0]
  def change
    add_column :container_images, :last_perf_capture_on, :datetime
  end
end
