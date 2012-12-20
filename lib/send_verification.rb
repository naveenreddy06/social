Notify.verify_registration(User.where("_id" => ARGV[0]).first).deliver
