using System;
using Ink.Runtime;
using UnityEngine;
using UnityEngine.UI;

// This is a super bare-bones example of how to play and display an Ink story in Unity.
public class BasicInkExample : MonoBehaviour
{
    public static event Action<Story> OnCreateStory;

    [SerializeField] private AudioSource audioSource; 
    [SerializeField] private AudioClip startStoryClip; //I was able to get a sound to start with the story, however could not get a sound to work for an onClick button sound

    void Awake()
    {
        RemoveChildren();
        StartStory();
    }

    // Creates a new Story object with the compiled story which we can then play!
    void StartStory()
    {
        // Play sound at the start of the story
        PlaySound(startStoryClip);

        story = new Story(inkJSONAsset.text);
        OnCreateStory?.Invoke(story);

        // Bind function to play sound from Ink if needed
        story.BindExternalFunction("play_start_sound", () => PlaySound(startStoryClip));

        RefreshView();
    }

    // Reusable function to play a sound
    void PlaySound(AudioClip clip)
    {
        if (audioSource != null && clip != null)
        {
            audioSource.PlayOneShot(clip);
        }
    }

    // This is the main function called every time the story changes. It does a few things:
    // Destroys all the old content and choices.
    // Continues over all the lines of text, then displays all the choices. If there are no choices, the story is finished!
    void RefreshView()
    {
        // Remove all the UI on screen
        RemoveChildren();

        // Read all the content until we can't continue any more
        while (story.canContinue)
        {
            string text = story.Continue();
            text = text.Trim(); // Remove white spaces
            CreateContentView(text);
        }

        // Display all the choices, if there are any!
        if (story.currentChoices.Count > 0)
        {
            for (int i = 0; i < story.currentChoices.Count; i++)
            {
                Choice choice = story.currentChoices[i];
                Button button = CreateChoiceView(choice.text.Trim());

                // Tell the button what to do when we press it
                button.onClick.AddListener(delegate {
                    OnClickChoiceButton(choice);
                });
            }
        }
        // If we've read all the content and there's no choices, the story is finished!
        else
        {
            Button choice = CreateChoiceView("End of story.\nRestart?");
            if (choice != null)
            {
                choice.onClick.AddListener(() => StartStory());
            }
            else
            {
                Debug.LogError("Failed to create Restart button!");
            }
        }
    }

    // When we click the choice button, tell the story to choose that choice!
    void OnClickChoiceButton(Choice choice)
    {
        // Stop the audio only if it's still playing the start story sound because the alarm will play through if we are already at work
        if (audioSource != null && audioSource.clip == startStoryClip && audioSource.isPlaying)
        {
            audioSource.Stop();
        }

        story.ChooseChoiceIndex(choice.index);
        RefreshView();
    }

    // Creates a textbox showing the line of text
    void CreateContentView(string text)
    {
        Text storyText = Instantiate(textPrefab) as Text;
        storyText.text = text;
        storyText.transform.SetParent(canvas.transform, false);
    }

    // Creates a button showing the choice text
    Button CreateChoiceView(string text)
    {
        Button choice = Instantiate(buttonPrefab) as Button;
        choice.transform.SetParent(canvas.transform, false);

        // Gets the text from the button prefab
        Text choiceText = choice.GetComponentInChildren<Text>();
        choiceText.text = text;

        // Make the button expand to fit the text
        HorizontalLayoutGroup layoutGroup = choice.GetComponent<HorizontalLayoutGroup>();
        layoutGroup.childForceExpandHeight = false;

        return choice; //no matter what I did in this section of changing script, I could not get the sound to work with the button outside of having the play on awake checked off in Unity. 
    }

    // Destroys all the children of this GameObject (all the UI)
    void RemoveChildren()
    {
        int childCount = canvas.transform.childCount;
        for (int i = childCount - 1; i >= 0; --i)
        {
            Destroy(canvas.transform.GetChild(i).gameObject);
        }
    }

    [SerializeField]
    private TextAsset inkJSONAsset = null;
    public Story story;

    [SerializeField]
    private Canvas canvas = null;

    // UI Prefabs
    [SerializeField]
    private Text textPrefab = null;
    [SerializeField]
    private Button buttonPrefab = null;
}
