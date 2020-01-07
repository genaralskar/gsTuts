using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationSwapper : MonoBehaviour
{
    public PlayerAnimations player;
    public Controller controller;
    public AnimationClip newClip;
    public bool utilExit = false;

    private void OnMouseDown()
    {
        if(player)
            player.AnimUtil(newClip, utilExit);
        
        if(controller)
            controller.AnimUtil(newClip, utilExit);
    }
}
