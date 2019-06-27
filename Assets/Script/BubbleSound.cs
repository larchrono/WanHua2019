using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BubbleSound : MonoBehaviour
{
    private void OnTriggerEnter(Collider other) {
        if(other.gameObject.tag == "KinectCollider"){
            //Debug.Log(other.gameObject.name);
            SoundTrigger.instance.PlayRandomSound();
        }
    }
}
