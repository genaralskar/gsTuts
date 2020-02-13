using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HealthUI : MonoBehaviour
{
    public Image healthBar;
    public Text currentHealth;
    
    private void Awake()
    {
        Health.HealthUpdated += HealthUpdatedHandler;
        
    }

    private void HealthUpdatedHandler(int currentHealth, int maxHealth)
    {
        this.currentHealth.text = currentHealth.ToString();

        healthBar.fillAmount = (float)currentHealth / (float)maxHealth;
    }
}
