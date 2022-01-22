using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameFlowController : MonoBehaviour
{
    [SerializeField] private SimpleCountdown _countdown;
    
    void Start()
    {
        _countdown.Init(75);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
