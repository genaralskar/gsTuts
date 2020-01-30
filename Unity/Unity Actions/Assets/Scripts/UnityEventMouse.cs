using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class UnityEventMouse : MonoBehaviour
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
