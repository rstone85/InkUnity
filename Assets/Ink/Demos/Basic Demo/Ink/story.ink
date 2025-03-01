// Basic Office Story. The objective is to complete the project by making good choices. If you don't finish by the deadline, you have to repeat the day.

VAR projectCompleted = false
VAR dayCounter = 0 // Start on Monday (0 = Monday, 6 = Sunday) instead of sequence
VAR clickCounter = 0

The alarm <i>buzzes</i>, pulling you from sleep. The scent of <color=brown>coffee</color> fills the air as you prepare for the day ahead. The birds chirping outside your window, a reminder: the early bird gets the worm.  
You gather your things and head out the door, ready or not, for another day at the office, hoping that today is the day you will meet your deadline and finish the project.  

+ [Head to work] 
    ~ clickCounter++
    -> office_morning

=== office_morning ===
~ projectCompleted = false

// Determine the current day based on dayCounter
{dayCounter == 0:  Today is <color=red> Monday </color>} //added colors to the different days
{dayCounter == 1:  Today is <color=blue> Tuesday</color>}
{dayCounter == 2:  Today is <color=yellow> Wednesday</color>}
{dayCounter == 3:  Today is <color=brown> Thursday</color>}
{dayCounter == 4:  Today is <color=purple> Friday </color>}
{dayCounter == 5:  Today is <color=orange> Saturday </color>}
{dayCounter == 6:  Today is <color=black> Sunday </color>}

{dayCounter >= 5: //removed the sequence because I couldn't figure out how to assign this
    You arrive at the office, <color=brown>coffee</color> in hand. 
    The lights are off. The doors are locked.
    <i>It's the weekend.</i> 
    You think..."How did this happen? What shall I do instead?"
    -> weekend_activities
- else: 
    You arrive at the office, <color=brown>coffee</color> in hand. Another day, another project to complete.
    -> work_choices
}

=== work_choices ===
You think to yourself... "Where do I start?"

* [Check emails] 
    ~ clickCounter++ 
    -> check_emails
* [Start working on the project] 
    ~ clickCounter++ 
    -> start_project
* [Chat with a coworker] 
    ~ clickCounter++ 
    -> chat_with_coworker
+ -> //fallback choice
    Today is the day you are going to make <i>good</i> choices and finally finish the project.
    ~ clickCounter++ 
    -> start_project

=== check_emails ===
You spend some time reading emails, but get distracted by unimportant messages.  

It seems that the company is planning a lot of social events that you really don't want to take part in. But it is always good to be a team player.  
-> midday

=== start_project ===
You sit down and focus on the project. The initial tasks are straightforward, but soon you hit a challenge.  

{~The requirement for the document is unclear.| The software crashes unexpectedly.|Your supervisor emails asking for an update sooner than expected.}

+ [Break down the task into smaller parts] 
    ~ clickCounter++ 
    -> break_down_task
+ [Try to power through without a plan] 
    ~ clickCounter++ 
    -> no_plan

=== break_down_task ===
You methodically tackle each part, making steady progress.  
Pretty proud of yourself, it's almost lunch time.  
~ projectCompleted = true  
-> midday

=== no_plan ===
You work frantically, but hit a roadblock and lose time.  
Thinking you should have broken down the work into smaller tasks, you rethink what you might be able to accomplish in the afternoon, but now lunch is approaching.  
-> midday

=== chat_with_coworker ===
<color=purple>Jennie</color> sits down next to you. She starts in on the gossip. As <color=purple>Jennie</color> talks you think about the work you have to get done today and rethink your decision to chat with her.  
    + [A Few Moments Later] //This is to be read in the Spongebob narrator voice
    ~ clickCounter++
Time flies when you aren't working on the project. You realize you have been talking longer than usual.  

The deadline keeps approaching, and the work isn't done. It's almost the afternoon.  
-> midday

=== midday ===
It's lunchtime. The office hums with the sounds of chatter. Everyone begins to make their way to the lunch room.  

+ [Eat in the lunch room with co-workers] 
    ~ clickCounter++ 
    -> lunch_with_coworkers
+ [Eat lunch at desk and continue working] 
    ~ clickCounter++ 
    -> lunch_at_desk
+ [Go out for lunch] 
    ~ clickCounter++ 
    -> lunch_outside

=== lunch_with_coworkers ===
Listening to the gossip, you really don't want to get involved.  
But the conversation is intriguing, so you stay until the hour is over, then head back to your desk.  
-> afternoon

=== lunch_at_desk ===
    You power through the afternoon, tuning out any distractions that might come up.
    ~ projectCompleted = true //changed this to trigger a completed project
    -> afternoon


=== lunch_outside ===
{projectCompleted:
    Feeling accomplished, you decide to take a quick nap. Unfortunately, you fall asleep and wake up to find the parking lot almost empty.
    +[Hurry back to your desk] //added extra choice so it didn't go straight to end of day text
    ~clickCounter++
    -> end_of_day
- else:
    You take a real break and clear your mind, but lose valuable time.
    -> afternoon
}

=== afternoon ===
The afternoon slump hits. You struggle to stay focused. Only a few hours are left in the day, and you know you can make it through.  

+ [Push through and work hard]
    ~ clickCounter++ 
    -> push_through
+ [Get another coffee]
    ~ clickCounter++ 
    -> coffee_break

=== push_through ===
You make some progress and are feeling good, however the deadline still looms, and the day is coming to an end.
    + [You hope you finish in time] -> end_of_day //added this to seperate the text 

=== coffee_break === //Week7 Broke this down further to ease the player needing to read as much on screen
<color=purple>Jennie</color> (<i>the chatty co-worker</i>) happens to be in the break room. She starts talking about how she is finished with her work, which reminds you about the pile of work on your desk.  
    + [Drink the coffee]
    ~ clickCounter++ //wasn't going to add this initially since it was to break up the scene. But a click is a click.
You drink your <color=brown>coffee</color> as you walk back to your office.  
The caffeine kicks in, but you’re still working on the project hoping you have enough time as the end of the day nears.  
        ++ [The Day is Over] 
        ~ clickCounter++ 
        -> end_of_day

=== end_of_day ===
{projectCompleted:
    Your project is finished. You can finally go home feeling satisfied. 
    Total choices needed to finish project: {clickCounter} //display counter
    -> END
- else:
    You didn’t finish your project. You’ll have to try again tomorrow and make <i>better</i> choices if you want to feel accomplished.  
        + [Go Home]
    ~ projectCompleted = false
    ~ dayCounter = (dayCounter + 1) % 7 // Move to the next day
    -> office_morning
}

=== weekend_activities ===
You take the weekend off. 
    Maybe some rest will help you be more productive next week.

+ [Relax at home] 
    ~ clickCounter++ 
    -> next_day
+ [Go out with friends]
    ~ clickCounter++ 
    -> next_day

=== next_day ===
~ dayCounter = (dayCounter + 1) % 7 // Move to the next day
-> office_morning
