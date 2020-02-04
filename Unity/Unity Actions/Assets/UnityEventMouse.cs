using System;
using UnityEngine;
using UnityEngine.Events;

public class UnityEventMouse : MonoBehaviour
{
    public UnityEvent onMouseDownEvent;
    public UnityEvent onMouseEnterEvent;
    public UnityEvent onMouseExitEvent;

    private void Awake()
    {
        onMouseEnterEvent.AddListener(DebugMouseOver);
    }

    private void OnMouseDown()
    {
        onMouseDownEvent?.Invoke();
    }

    private void OnMouseEnter()
    {
        onMouseEnterEvent?.Invoke();
    }

    private void OnMouseExit()
    {
        onMouseExitEvent?.Invoke();
    }

    private void DebugMouseOver()
    {
        Debug.Log("Mouse Over");
    }
}
