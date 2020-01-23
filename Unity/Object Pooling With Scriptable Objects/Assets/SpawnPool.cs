using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnPool : MonoBehaviour
{
    public GameObjectPool pool;
    
    // Start is called before the first frame update
    void Awake()
    {
        pool.SpawnPool();
    }

}
