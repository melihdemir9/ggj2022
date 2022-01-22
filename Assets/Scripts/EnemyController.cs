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
    [SerializeField] [Range(5, 20)] private int maxSpeed = 10;
    
    private NavMeshAgent _agent;
    
    private void OnEnable()
    {
        _agent = GetComponent<NavMeshAgent>();
        _agent.speed = maxSpeed * ((GameFlowController.Instance.KeyProgress + 1f) / (GameFlowController.Instance.TotalKeyCount + 1f));
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
