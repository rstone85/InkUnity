using Ink.Runtime;
using TMPro;
using UnityEngine;

public class CounterObserver : MonoBehaviour
{
    public TextMeshProUGUI textfield; 

    private void Awake()
    {
        BasicInkExample.OnCreateStory += OnCreateStoryListener;
            }
    private void OnDestroy()
    {
        BasicInkExample.OnCreateStory -= OnCreateStoryListener;
    }
    void OnCreateStoryListener(Story story) {
        story.ObserveVariable("clickCounter", ObserveClickCounter);
    }
    void ObserveClickCounter(string varName, object newValue) 
    {
        UpdateText(newValue.ToString());
    }

    void UpdateText(string newtext)
    {
        textfield.text = newtext;

    }

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
