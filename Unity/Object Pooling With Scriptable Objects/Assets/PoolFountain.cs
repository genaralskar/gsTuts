using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PoolFountain : MonoBehaviour
{
    public GameObjectPool pool;
    
    public float spawnTime = .1f;

    public float force = 50;
    
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(Spawn());
    }

    private IEnumerator Spawn()
    {
        while (true)
        {
            GameObject obj = pool.GetPooledObject(transform.position, transform.rotation);
            Rigidbody rb = obj.GetComponent<Rigidbody>();
            if (rb)
            {
                rb.AddForce(transform.up * force);
            }
            
            yield return new WaitForSeconds(spawnTime);
        }
    }
}
