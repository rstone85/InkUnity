using Ink.Runtime;
using UnityEngine;

public class InkTesting1 : MonoBehaviour
{
    public TextAsset inkJSON;
    private Story story;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        story = new Story(inkJSON.text);
        Debug.Log(story.Continue());
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
