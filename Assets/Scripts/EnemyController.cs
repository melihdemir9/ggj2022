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
    // Start is called before the first frame update
    IEnumerator Start()
    {
        _agent = GetComponent<NavMeshAgent>();

        yield return new WaitUntil(() => GameFlowController.Instance.IsReady);
    }

    // Update is called once per frame
    void Update()
    {
        _agent.speed = maxSpeed * (GameFlowController.Instance.KeyProgress / GameFlowController.Instance.TotalKeyCount);
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
