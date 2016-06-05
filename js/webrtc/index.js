let me = document.querySelector('.me'),
    them = document.querySelector('.them'),
    input = document.querySelector('.input'),
    say = document.querySelector('.say'),
    call = document.querySelector('.call'),
    convo = document.querySelector('.convo'),
    answer = document.querySelector('.answer'),
    socket = io.connect('http://localhost:1337'),
    servers = [
        {
            iceServers: [
                {
                    url: 'stun:stun.l.google.com:19302'
                }
            ]
        }
    ],
    sdpConstraints = {
        optional: [],
        mandatory: {
            OfferToReceiveAudio: true,
            OfferToReceiveVideo: true
        }
    },
    submitChat = () => {
        convo.innerHTML += 'You: '+input.value + '<br/>';
        convo.scrollTop = convo.scrollHeight;
        input.value = '';
    },
    pc = null,
    rxDesc = (msg) => {
        console.log('rxDesc', msg)
        let desc = new RTCSessionDescription(JSON.parse(atob(msg)));
        console.log('using', desc);
        pc.setRemoteDescription(desc)
            .then((r)=>console.log(r))
            .catch((e)=>console.log(e));
    },
    rxCandidate = (msg) => {
        console.log('rxCandidate', msg)
        pc.addIceCandidate(new RTCIceCandidate(JSON.parse(atob(msg))))
            .then((r) => console.log(r))
            .catch((e) => console.log(e));
    },
    doCall = () => {
        console.log('calling')
        pc.createOffer({}).then((desc) => {
            console.log('called', desc);
            pc.setLocalDescription(desc);
            socket.emit('desc', btoa(JSON.stringify(desc.toJSON())));
        }).catch((err)=>console.log(err));
    },
    doAnswer = () => {
        console.log('answering')
        if (!pc.remoteDescription) {
            console.log('dunno who to answer to, no one called us');
            return;
        }
        pc.createAnswer().then((desc)=> {
            pc.setLocalDescription(desc);
            socket.emit('desc', btoa(JSON.stringify(desc.toJSON())));
        }).catch((e)=>console.log(e));
    },
    run = () => {

        socket.on('connect', () => {
            console.log('connected')
            socket.emit('message', {hello: 'world'});
            socket.on('message', (msg) => {
                if ('desc' == msg.type) rxDesc(msg.data);
                if ('candidate' == msg.type) rxCandidate(msg.data);
                console.log('msg', msg);
            });

            //socket.on('desc', (msg) => rxDesc);
            //socket.on('candidate', (msg) => rxCandidate);


            navigator.mediaDevices.getUserMedia({audio: true, video: true})
            .then((stream) => {
                let objUrl = window.URL.createObjectURL(stream);
                me.src = objUrl;
                me.addEventListener('loadedmetadata', () => me.play());

                pc = new RTCPeerConnection(servers);

                pc.addEventListener('signalingstatechange', () => {
                    console.log('new state is', pc.signalingState);
                });

                stream.getTracks().forEach(track => pc.addTrack(track, stream));

                //let channel = pc.createDataChannel('test', {reliable: true});

                //channel.addEventListener('open', (ev) => {
                //    console.log('data channel open');
                //});

                //channel.addEventListener('message', (ev) => {
                //    console.log('data channel message', ev.data);
                //});

                pc.addEventListener('connection', (ev) => {
                    console.log('connection', ev);
                });

                pc.addEventListener('icecandidate', (ev) => {
                    console.log('icecandidate', ev.candidate)
                    if (ev.candidate)
                        socket.emit('candidate', btoa(JSON.stringify(ev.candidate.toJSON())));
                });

                pc.addEventListener('iceconnectionstatechange', (ev) => {
                    console.log('iceconnectionstatechange', pc.iceConnectionState, ev);
                })

                pc.addEventListener('icegatheringstatechange', (ev) => {
                    console.log('icegatheringstatechange', pc.iceGatheringState, ev);
                })

                pc.addEventListener('negotiationneeded', (ev) => {
                    console.log('negotiationneeded', ev);
                })

                pc.addEventListener('removestream', (ev) => {
                    console.log('removestream', ev);
                })

                pc.addEventListener('datachannel', (ev) => {
                    console.log('datachannel', ev);
                })

                pc.addEventListener('close', (ev) => {
                    console.log('close', ev);
                })

                pc.addEventListener('error', (ev) => {
                    console.log('error', ev);
                })

                pc.addEventListener('message', (ev) => {
                    console.log('message', ev);
                })

                pc.addEventListener('open', (ev) => {
                    console.log('open', ev);
                })

                pc.addEventListener('tonechange', (ev) => {
                    console.log('tonechange', ev);
                })

                pc.addEventListener('identiyresult', (ev) => {
                    console.log('identiyresult', ev);
                })

                pc.addEventListener('idpassertionerror', (ev) => {
                    console.log('idpassertionerror', ev);
                })

                pc.addEventListener('idpvalidationerror', (ev) => {
                    console.log('idpvalidationerror', ev);
                })

                pc.addEventListener('peeridentity', (ev) => {
                    console.log('peeridentity', ev);
                })

                pc.addEventListener('isolationchange', (ev) => {
                    console.log('isolationchange', ev);
                })


                pc.addEventListener('addstream', (ev) => {
                    console.log('addstream', ev.stream);
                    them.src = URL.createObjectURL(ev.stream);
                    them.addEventListener('loadedmetadata', () => them.play());
                });

                call.addEventListener('click', doCall),
                answer.addEventListener('click', doAnswer);
            })
            .catch((e) => console.log(e));
        });
    };

run();
say.addEventListener('click', submitChat);
input.addEventListener('keypress', (ev) => {
    if ('Enter' == ev.key) submitChat();
});
