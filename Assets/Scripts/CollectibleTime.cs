using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollectibleTime : MonoBehaviour
{
    [SerializeField] private int _timeToAdd;
    
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            GameFlowController.Instance.AddTime(_timeToAdd);
            Destroy(gameObject);
        }
    }
}
