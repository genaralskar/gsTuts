using UnityEngine;
using UnityEngine.AI;

[RequireComponent(typeof(NavMeshAgent))]
public class Controller : MonoBehaviour
{

    private NavMeshAgent agent;
    public LayerMask layerMask = -1;

    private void Awake()
    {
        agent = GetComponent<NavMeshAgent>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            MovePlayer();
        }
    }

    private void MovePlayer()
    {
        Ray ray = Camera.main.ScreenPointToRay((Input.mousePosition));
        if (Physics.Raycast(ray, out var hit, Mathf.Infinity, layerMask))
        {
            agent.SetDestination(hit.point);
        }
    }
}
