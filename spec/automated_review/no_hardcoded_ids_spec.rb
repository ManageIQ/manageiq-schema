describe "Hardcoded ids" do
  def hardcoded_ids_message(files)
    <<~EOMSG
      Hardcoded id numbers were found in the following locations:

      #{files.join("\n").indent(4)}

      Hardcoded id numbers should not be present in a data migration spec, as
      they ignore region numbers, creating an invalid database setup. Instead,
      use the following helper to generate ids in the correct region:

          # Example, in region 1, requesting id number 2
          anonymous_class_with_id_regions.id_in_region(2, anonymous_class_with_id_regions.my_region_number)
          # => 1000000000002

      If you believe this file is a false postive, add the following as a
      tailing comment to the line in question

          # manageiq:disable HardcodedIds

    EOMSG
  end

  it "should not be found in specs" do
    hardcoded_ids = Dir.chdir(ManageIQ::Schema::Engine.root) do
      `grep -n "_\\?id\\s*=>\\?\\s*[0-9]" spec/**/*_spec.rb | grep -v "manageiq:disable HardcodedIds"`.strip.split("\n")
    end

    expect(hardcoded_ids).to be_empty, hardcoded_ids_message(hardcoded_ids)
  end
end
