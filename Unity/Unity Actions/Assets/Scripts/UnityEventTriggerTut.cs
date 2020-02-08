using UnityEngine;
using UnityEngine.Events;

public class UnityEventTriggerTut : MonoBehaviour
{
    public UnityEvent OnTriggerEnterEvent;
    public UnityEvent OnTriggerExitEvent;

    private void OnTriggerEnter(Collider other)
    {
        OnTriggerEnterEventInvoke();
    }

    private void OnTriggerExit(Collider other)
    {
        OnTriggerExitEvent?.Invoke();
    }

    public void OnTriggerEnterEventInvoke()
    {
        OnTriggerEnterEvent?.Invoke();
    }
}
