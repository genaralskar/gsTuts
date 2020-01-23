using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Pools/Game Object Pool")]
public class GameObjectPool : ScriptableObject
{
    public GameObject prefab;

    public int amount;
    
    private Queue<GameObject> spawnedObjs;

    private Transform parent;

    public void SpawnPool()
    {
        if (spawnedObjs == null || spawnedObjs.Count == 0)
        {
            spawnedObjs = new Queue<GameObject>();
        }

        if (spawnedObjs.Count >= amount)
        {
            return;
        }

        if (!parent)
        {
            parent = new GameObject(name).transform;
        }

        while (spawnedObjs.Count < amount)
        {
            GameObject obj = Instantiate(prefab, parent);
            obj.SetActive(false);
            spawnedObjs.Enqueue(obj);
        }
    }

    public GameObject GetPooledObject(Vector3 newPos, Quaternion newRot)
    {
        if (spawnedObjs == null || spawnedObjs.Count == 0)
        {
            SpawnPool();
            Debug.LogWarning($"{name} spawned mid-game. Consider spawning it at the start of the game");
        }

        GameObject obj = spawnedObjs.Dequeue();
        
        spawnedObjs.Enqueue(obj);
        obj.SetActive(false);
        
        obj.transform.position = newPos;
        obj.transform.rotation = newRot;
        obj.SetActive(true);

        return obj;
    }
}
