using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAnimations : MonoBehaviour
{
    public Animator anims;
    public AnimationClip utilClip;
    
    private AnimatorOverrideController animsOverride;
    
    
    private void Awake()
    {
        animsOverride = new AnimatorOverrideController(anims.runtimeAnimatorController);
        anims.runtimeAnimatorController = animsOverride;
    }

    public void AnimUtil(AnimationClip clip, bool utilExit = false)
    {
        animsOverride[utilClip] = clip;
        anims.SetBool("UtilExit", utilExit);
        anims.SetTrigger("Util");
    }
}
