using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BubbleSound : MonoBehaviour
{
    public AudioSource mainSource;


    private void OnTriggerEnter(Collider other) {
        if(other.gameObject.tag == "KinectCollider"){
            Debug.Log(other.gameObject.name);
            //mainSource.PlayOneShot(mainSource.clip);
            GameObject temp = Instantiate(mainSource.gameObject);
            Destroy(temp,3);
        }
    }
}
