
require 'cinch'

bot = Cinch::Bot.new do

  configure do |c|
    c.server   = 'irc.freenode.org'
    c.channels = ['#5by5']
    c.nick = 'fivebyfunbot'
  end

  on :message, /^!merlin/ do |m|
    m.reply [
      "SO angry.",
      "Don't be creepy.",
      "Go ahead, caller.",
      "Is this what people tune in for?",
      "I love you.",
      "Recursion. Which is also known as recursion.",
      "...Cleric...",
      "I gotta go bust a tinkie."
    ].sample
  end

  on :message, /^!jsir/ do |m|
    m.reply [
      "perl -le '$n=10; $min=5; $max=15; $, = \" \"; print map { int(rand($max-$min))+$min } 1..$n'",
      "perl -le '$i=3; $u += ($_<<8*$i--) for \"127.0.0.1\" =~ /(\d+)/g; print $u'",
      "perl -MAlgorithm::Permute -le '$l = [1,2,3,4,5]; $p = Algorithm::Permute->new($l); print @r while @r = $p->next'",
      "perl -lne '(1x$_) !~ /^1?$|^(11+?)\\1+$/ && print \"$_ is prime\"'",
      "perl -ple 's/^[ \\t]+|[ \\t]+$//g'",
      "perl -e 'say \"Like an animal!\"'"
    ].sample
  end

  on :message, /^!haddie/ do |m|
    m.reply [
      "That's meat, I know it.",
      "Oh, it's fabulous.",
      "No, no, no one's screwing a hole",
      "It's a sensation",
      "Eww, the cat is weird",
      "We have to worry about space germs too. Ughhhhhhhhh! Why?!?!",
      "I don't think that is the proper way to do it.",
      "The little...the little long box.",
      "'scuse me!",
      "*gasp*",
      "OH MY GOSH!",
      "The UK"
    ].sample
  end

  on :message, /^!neckbeard/ do |m|
    m.reply [
      "Erm, so."
    ].sample
  end

  on :message, /^!marco/ do |m|
    m.reply [
      "Please don't email me.",
      "I shouldn't have said that.",
      "Braaaaands"
    ].sample
  end

  on :message, /^!dan/ do |m|
    m.reply [
      "That's fine for Merlin.",
      "Big week. Huge week.",
      "It's your show.",
      "Go ahead caller.",
      "Keeping you up, Haddie?",
      "Who comes in here and changes everything!?!?"
    ].sample
  end

  on :message, /^!quit/ do |m|
    m.reply "Call in to Quit! Live at (512) 518-5714. Leave a Voicemail at (512) 222-8141."
  end

  on :message, /^!showbot/ do |m|
    m.reply "To submit titles type \"!s Title to suggest\" (without quotes). To vote on titles go to http://showbot.5by5.tv"
  end

  on :message, /^!dlc/ do |m|
    m.reply "Call in to DLC Live at (512) 518-5714."
  end

  on :message, /^!rant/ do |m|
    m.reply [
      "Skype is the WORST!",
      "Smart TVs are the WORST!",
      "Python is the WORST! Who wants all those tabs!"
      ].sample
  end

  on :message, /^!jim/ do |m|
    m.reply 'HaHa' * rand(20)
  end

  on :message, /^!earworm/ do |m|
    m.reply 'http://www.youtube.com/djearworm'
  end

  on :message, /^!recursion/ do |m|
    m.reply '!recursion'
  end

  on :message, /^!soundboard/ do |m|
    m.reply [
      'WHAT!',
      'OK!',
      'YEAH!',
      'Whoa-ha-ho!',
      'Theatre of the mind',
      'That\'s your name dude',
      'Do NOT...go in there!',
      'Mark it zero, next frame.',
      'I don\'t stop nothing, you idiot',
      'Ding ding ding',
      'Bzzzzzzzzzzzzt',
      "What what what!",
      "Hmmmmmmmm!",
      "RAWR!",
      "Hah heh",
      "Hegh! I need to sleep!",
      "USA! USA! USA!",
      "Third prize is you're fired.",
      "Way of the future",
      "Egh, I want to get this right so show me the blueprints",
      "Coffee is for closers",
      "I used to be a salesman ... tough racket.",
      "They're going to kill that poor woman."
    ].sample
  end

  on :message, /^!liljohn/ do |m|
    m.reply [
      'WHAT!',
      'OK!',
      'YEAH!',
      'What\'s happening?!'
    ].sample
  end

  on :message, /^!help/ do |m|
    m.user.send "Commands: !merlin, !dan, !haddie, !neckbeard, !marco, !jsir, !quit, !jim, !dlc, !rant, !earworm, !soundboard, !liljohn, !showbot, !recursion"
  end

end


bot.start

