using UnityEngine;
using UnityEngine.Events;

public class UnityEventMouseTut : MonoBehaviour
{
    public UnityEvent OnMouseDownEvent;
    public UnityEvent OnMouseEnterEvent;
    public UnityEvent OnMouseExitEvent;

    private void OnMouseDown()
    {
        OnMouseDownEvent?.Invoke();
    }

    private void OnMouseEnter()
    {
        OnMouseEnterEvent?.Invoke();
    }

    private void OnMouseExit()
    {
        OnMouseExitEvent?.Invoke();
    }
}
