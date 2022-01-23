using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class EnemyController : MonoBehaviour
{
    [SerializeField] private Transform player;
    [SerializeField] private Transform canvas;
    [SerializeField] private GameObject gameOverScreen;
    [SerializeField] [Range(20, 100)] private int maxSpeed = 25;
    
    private NavMeshAgent _agent;
    private AudioSource _as;
    
    private void OnEnable()
    {
        _as = GetComponent<AudioSource>();
        _agent = GetComponent<NavMeshAgent>();
        _agent.speed = maxSpeed * ((GameFlowController.Instance.KeyProgress + 1f) / (GameFlowController.Instance.TotalKeyCount + 1f));

       
        if (PlayerPrefs.GetInt("sfxOn", 1) == 1)
        {
            _as.loop = true;
            _as.Play();
        }
    }

    private void OnDisable()
    {
        _as.Stop();
    }

    // Update is called once per frame
    void Update()
    {
        _agent.SetDestination(player.position);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            Instantiate(gameOverScreen, canvas);
        }
    }
}
