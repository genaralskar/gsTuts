using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Light))]
public class LightToggle : MonoBehaviour
{
    private Light light;

    private void Awake()
    {
        light = GetComponent<Light>();
    }

    public void ToggleLight()
    {
        light.enabled = !light.enabled;
    }
}
