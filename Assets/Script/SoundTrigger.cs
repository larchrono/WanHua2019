using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundTrigger : MonoBehaviour
{
    public static SoundTrigger instance;
    public List<AudioClip> allClip;

    public AudioSource SoundPlayer;
    
    void Awake() {
        instance = this;
    }

    void Start()
    {
        SoundPlayer = GetComponent<AudioSource>();
    }

    public void PlayRandomSound(){
        SoundPlayer.PlayOneShot(allClip[Random.Range(0,allClip.Count)]);
    }
}
