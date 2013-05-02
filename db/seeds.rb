FeedType.create(:post_type => "Update")
FeedType.create(:post_type => "Photos")
FeedType.create(:post_type => "Videos")
FeedType.create(:post_type => "Events")
FeedType.create(:post_type => "Deals")


emtp1 = EmotionType.create(:name => "Positive emotions")
emtp2 = EmotionType.create(:name => "Negative emotions")

Emotion.create(:name => "Lovely", :emotion_type_id => emtp1.id)
Emotion.create(:name => "Funny", :emotion_type_id => emtp1.id)
Emotion.create(:name => "Omg!", :emotion_type_id => emtp1.id)
Emotion.create(:name => "Festive", :emotion_type_id => emtp1.id)


Emotion.create(:name => "Mad", :emotion_type_id => emtp2.id)
Emotion.create(:name => "Sad", :emotion_type_id => emtp2.id)
Emotion.create(:name => "Creepy", :emotion_type_id => emtp2.id)
Emotion.create(:name => "Yucky", :emotion_type_id => emtp2.id)
["Angry", "Awesome", "Creepy", "Funny", "Lovely", "OMG", "Sad", "Yucky"].each do |mood|
CommentMood.create(:name => mood, :enabled_image => "/img/Emotions/Enabled/#{mood}_E.png" , :disabled_image => "/img/Emotions/Disabled/#{mood}_D.png")
end
