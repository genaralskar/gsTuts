using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Controller : MonoBehaviour
{
    public Animator anims;
    public AnimationClip utilClip;
    
    private AnimatorOverrideController animsOverride;

    public float maxSpeed = 3.5f;
    
    private NavMeshAgent agent;

    private void Awake()
    {
        animsOverride = new AnimatorOverrideController(anims.runtimeAnimatorController);
        anims.runtimeAnimatorController = animsOverride;
        
        agent = GetComponent<NavMeshAgent>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

            if (Physics.Raycast(ray, out var hit))
            {
                if (hit.transform.gameObject.layer == LayerMask.NameToLayer("Ground"))
                {
                    Move(hit.point);
                }
            }
        }
        
        UpdateRunSpeed();
    }

    private void Move(Vector3 newPos)
    {
        anims.SetBool("UtilStop", true);
        agent.SetDestination(newPos);
    }
    
    public void AnimUtil(AnimationClip clip, bool utilExit = false)
    {
        animsOverride[utilClip] = clip;
        anims.SetBool("UtilStop", false);
        anims.SetBool("UtilExit", utilExit);
        anims.SetTrigger("Util");
    }

    private void UpdateRunSpeed()
    {
        //float norm = agent.velocity.magnitude / maxSpeed;
        
        anims.SetFloat("RunSpeed", agent.velocity.magnitude);
    }
}
