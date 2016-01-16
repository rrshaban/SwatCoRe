namespace :serialize do
  
  desc "Convert all CRNs that are strings to arrays"
  task crns: :environment do
    Course.all.each do |c|
      if c.crn.class == String then
        c.update_attributes(crn: [c.crn])
      end
    end
  end

  desc "TODO"
  task professors: :environment do
  end

end
