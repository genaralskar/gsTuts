using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(Collider))]
public class UnityEventTrigger : MonoBehaviour
{
    [SerializeField]
    private UnityEvent onTriggerEnterEvent;

    [SerializeField]
    private UnityEvent onTriggerExitEvent;

    [HideInInspector]
    public float asd;
    
    private void OnTriggerEnter(Collider other)
    {
        onTriggerEnterEvent?.Invoke();
    }

    private void OnTriggerExit(Collider other)
    {
        onTriggerExitEvent?.Invoke();
    }

}
