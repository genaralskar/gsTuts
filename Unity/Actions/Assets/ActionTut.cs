using UnityEngine;
using UnityEngine.Events;

public class ActionTut : MonoBehaviour
{
    public UnityAction TestAction;

    private void Start()
    {
        for (int i = 0; i < 3; i++)
        {
            GameObject child = new GameObject($"child{i}");
            ActionChild kid = child.AddComponent<ActionChild>();
            TestAction += kid.TestActionHandler;
        }
    }
    
    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            TestAction?.Invoke();
        }
    }
    
    
}
