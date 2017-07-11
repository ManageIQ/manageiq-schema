class ConvertCustomButtonToClasses < ActiveRecord::Migration[5.0]
  class CustomButton < ActiveRecord::Base
    serialize :options
  end

  class MiqSet < ActiveRecord::Base
    serialize :set_data
  end

  def up
    say_with_time("Convert old style custom button icons to fonticon classes + hex colors") do
      CustomButton.select(:id, :options).each do |button|
        next unless button.options[:button_image]
        button.options.merge!(convert_up(button.options))
        button.options.delete(:button_image)
        button.save
      end
    end

    say_with_time("Convert old style custom button set icons to fonticon classes + hex colors") do
      MiqSet.select(:id, :set_data).where(:set_type => 'CustomButtonSet').each do |button|
        next unless button.set_data[:button_image]
        button.set_data.merge!(convert_up(button.set_data))
        button.set_data.delete(:button_image)
        button.save
      end
    end
  end

  def down
    say_with_time("Convert fonticon classes in custom buttons back to old style") do
      CustomButton.select(:id, :options).each do |button|
        button.options.delete(:button_color)
        next unless button.options[:button_icon]
        button.options[:button_image] = convert_down(button.options)
        button.options.delete(:button_icon)
        button.save
      end
    end

    say_with_time("Convert fonticon classes in custom button sets back to old style") do
      MiqSet.select(:id, :set_data).where(:set_type => 'CustomButtonSet').each do |button|
        button.set_data.delete(:button_color)
        next unless button.set_data[:button_icon]
        button.set_data[:button_image] = convert_down(button.set_data)
        button.set_data.delete(:button_icon)
        button.save
      end
    end
  end

  private

  def convert_up(btn)
    icon = {}

    case btn[:button_image]
    when 1
      icon[:button_icon] = 'ff ff-hexagon'
      icon[:button_color] = '#2d7623'
    when 2
      icon[:button_icon] = 'ff ff-wavy-lines'
      icon[:button_color] = '#00659c'
    when 3
      icon[:button_icon] = 'ff ff-diamond'
      icon[:button_color] = '#f5c12e'
    when 4
      icon[:button_icon] = 'fa fa-star'
      icon[:button_color] = '#2d7623'
    when 5
      icon[:button_icon] = 'fa fa-circle'
      icon[:button_color] = '#ec7a08'
    when 6
      icon[:button_icon] = 'ff ff-database-squeezed'
    when 7
      icon[:button_icon] = 'ff ff-broom'
    when 8
      icon[:button_icon] = 'ff ff-triangle'
      icon[:button_color] = '#cc0000'
    when 9
      icon[:button_icon] = 'fa fa-angle-double-down'
      icon[:button_color] = '#00659c'
    when 10
      icon[:button_icon] = 'fa fa-angle-double-up'
      icon[:button_color] = '#00659c'
    when 11
      icon[:button_icon] = 'fa fa-angle-double-left'
      icon[:button_color] = '#00659c'
    when 12
      icon[:button_icon] = 'fa fa-angle-double-right'
      icon[:button_color] = '#00659c'
    when 13
      icon[:button_icon] = 'ff ff-synchronize'
      icon[:button_color] = '#00659c'
    when 14
      icon[:button_icon] = 'fa fa-refresh'
      icon[:button_color] = '#2d7623'
    when 15
      icon[:button_icon] = 'fa fa-power-off'
      icon[:button_color] = '#cc0000'
    else
      icon[:button_icon] = 'ff ff-hexagon'
    end

    icon
  end

  def convert_down(btn)
    case btn[:button_icon]
    when 'ff ff-hexagon'
      1
    when 'ff ff-wavy-lines'
      2
    when 'ff ff-diamond'
      3
    when 'fa fa-star'
      4
    when 'fa fa-circle'
      5
    when 'ff ff-database-squeezed'
      6
    when 'ff ff-broom'
      7
    when 'ff ff-triangle'
      8
    when 'fa fa-angle-double-down'
      9
    when 'fa fa-angle-double-up'
      10
    when 'fa fa-angle-double-left'
      11
    when 'fa fa-angle-double-right'
      12
    when 'ff ff-synchronize'
      13
    when 'fa fa-refresh'
      14
    when 'fa fa-power-off'
      15
    else
      1
    end
  end
end
