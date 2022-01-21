using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    private Rigidbody _rb;
    [Range(1, 20)] 
    public float Speed = 8;

    [SerializeField] private Camera mainCamera;
    
    // Start is called before the first frame update
    void Start()
    {
        _rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");
        float cosrot = Mathf.Cos(mainCamera.transform.rotation.eulerAngles.y * Mathf.Deg2Rad);
        float sinrot = Mathf.Sin(mainCamera.transform.rotation.eulerAngles.y * Mathf.Deg2Rad);
        Debug.Log("sin " + sinrot + "  cos " + cosrot);
        
        _rb.velocity = new Vector3((vertical * sinrot + horizontal * cosrot) * Speed, 0, (vertical * cosrot - horizontal * sinrot) * Speed);
        if(Mathf.Abs(horizontal) + Mathf.Abs(vertical) > 0.01f) transform.rotation = Quaternion.LookRotation(_rb.velocity);
    }
}
