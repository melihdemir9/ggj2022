using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollectibleKey : MonoBehaviour
{
    private AudioSource _as;

    private void OnEnable()
    {
        _as = GetComponent<AudioSource>();
        _as.loop = true;
        _as.Play();
    }

    private void OnDisable()
    {
        _as.Stop();
    }

    private void Update()
    {
        _as.volume = GameFlowController.Instance.GetProximityVolumeForKey(transform.position);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            GameFlowController.Instance.IterateKey(gameObject);
        }
    }
}
