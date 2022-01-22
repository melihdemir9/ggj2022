using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    private Rigidbody _rb;
    private AudioSource _footsteps;
    [Range(1, 20)] 
    public float Speed = 8;

    [SerializeField] private Camera mainCamera;
    
    // Start is called before the first frame update
    void Start()
    {
        _rb = GetComponent<Rigidbody>();
        _footsteps = GetComponent<AudioSource>();

        _footsteps.volume = 0;
        _footsteps.loop = true;
        _footsteps.Play();
    }

    // Update is called once per frame
    void Update()
    {
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");
        float cosrot = Mathf.Cos(mainCamera.transform.rotation.eulerAngles.y * Mathf.Deg2Rad);
        float sinrot = Mathf.Sin(mainCamera.transform.rotation.eulerAngles.y * Mathf.Deg2Rad);
        
        _rb.velocity = new Vector3((vertical * sinrot + horizontal * cosrot) * Speed, 0, (vertical * cosrot - horizontal * sinrot) * Speed);
        if (Mathf.Abs(horizontal) + Mathf.Abs(vertical) > 0.01f)
        {
            _footsteps.volume = Mathf.Clamp01(Mathf.Abs(horizontal) + Mathf.Abs(vertical));
            transform.rotation = Quaternion.LookRotation(_rb.velocity);
        }
        else
        {
            _footsteps.volume = 0;
        }

        if (Input.GetKeyDown(KeyCode.KeypadPlus)) Speed++;
        if (Input.GetKeyDown(KeyCode.KeypadMinus)) Speed--;
    }
}
