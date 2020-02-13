using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Health : MonoBehaviour
{
    public static UnityAction<int, int> HealthUpdated;

    public int currentHealth;
    public int maxHealth = 10;

    private void OnEnable()
    {
        currentHealth = maxHealth;
    }
    
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            ModifyHealth(1);
        }

        if (Input.GetMouseButtonDown(1))
        {
            ModifyHealth(-1);
        }
    }

    public void ModifyHealth(int amount)
    {
        currentHealth += amount;
        currentHealth = Mathf.Clamp(currentHealth, 0, maxHealth);
        HealthUpdated?.Invoke(currentHealth, maxHealth);

        if (currentHealth <= 0)
        {
            currentHealth = 0;
            //dead
        }
    }
}
