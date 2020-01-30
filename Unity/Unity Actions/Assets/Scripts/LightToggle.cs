using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Light))]
public class LightToggle : MonoBehaviour
{
    private bool active;
    private Light light;

    private void Awake()
    {
        light = GetComponent<Light>();
        active = light.enabled;
    }

    public void ToggleLight()
    {
        light.enabled = !active;
        active = light.enabled;
    }
}
