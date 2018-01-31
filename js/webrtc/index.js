let me = document.querySelector(`.me`),
    them = document.querySelector(`.them`),
    input = document.querySelector(`.input`),
    say = document.querySelector(`.say`),
    call = document.querySelector(`.call`),
    convo = document.querySelector(`.convo`),
    answer = document.querySelector(`.answer`),
    hangup = document.querySelector(`.hangup`),
    socket = io.connect(`http://localhost:1337`),
    servers = [
        {
            iceServers: [
                {
                    url: `stun:stun.l.google.com:19302`
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
    appendToLog = (msg) => {
        convo.innerHTML += msg + `<br/>`;
        convo.scrollTop = convo.scrollHeight;
        input.value = ``;
    },
    submitChat = () => {
        if (channel)
            channel.send(input.value);
        appendToLog(`You: `+input.value);
    },
    pc = null,
    channel = null,
    stream = null,
    rxDesc = (msg) => {
        if (`closed` == pc.signalingState) return;
        let desc = new RTCSessionDescription(JSON.parse(atob(msg)));
        if (`offer` == desc.type) {
            call.style.display = `none`;
            answer.style.display = `block`;
        }
        if (`answer` == desc.type) {
            say.style.display = `block`;
            input.style.display = `block`;
        }
        pc.setRemoteDescription(desc)
            .then((r)=>console.log(r))
            .catch((e)=>console.log(e));
    },
    rxCandidate = (msg) => {
        if (`closed` == pc.signalingState) return;
        pc.addIceCandidate(new RTCIceCandidate(JSON.parse(atob(msg))))
            .then((r) => console.log(r))
            .catch((e) => console.log(e));
    },
    doHangup = () => {
        console.log(`hanging up`);
        pc.close();


        call.style.display = `block`;
        hangup.style.display = `none`;
        say.style.display = `none`;
        input.style.display = `none`;
    },
    doCall = () => {
        if (`closed` == pc.signalingState) {
            setupPeerConnection();
            setupDataChannel();
        }
        console.log(`calling`);
        call.style.display = `none`;
        answer.style.display = `none`;
        hangup.style.display = `block`;

        pc.createOffer({}).then((desc) => {
            console.log(`called`, desc);
            pc.setLocalDescription(desc);
            socket.emit(`desc`, btoa(JSON.stringify(desc.toJSON())));
        }).catch((err)=>console.log(err));
    },
    doAnswer = () => {
        console.log(`answering`);
        call.style.display = `none`;
        answer.style.display = `none`;
        hangup.style.display = `block`;

        say.style.display = `block`;
        input.style.display = `block`;

        if (!pc.remoteDescription) {
            console.log(`dunno who to answer to, no one called us`);
            return;
        }
        pc.createAnswer().then((desc)=> {
            pc.setLocalDescription(desc);
            socket.emit(`desc`, btoa(JSON.stringify(desc.toJSON())));
        }).catch((e)=>console.log(e));
    },
    setupPeerConnection = () => {
        pc = new RTCPeerConnection(servers);

        pc.addEventListener(`signalingstatechange`, () => {
            console.log(`new state is`, pc.signalingState);
        });

        stream.getTracks().forEach(track => pc.addTrack(track, stream));

        pc.addEventListener(`connection`, (ev) => {
            console.log(`connection`, ev);
        });

        pc.addEventListener(`icecandidate`, (ev) => {
            //console.log('icecandidate', ev.candidate)
            if (ev.candidate)
                socket.emit(`candidate`, btoa(JSON.stringify(ev.candidate.toJSON())));
        });

        pc.addEventListener(`iceconnectionstatechange`, (ev) => {
            console.log(`iceconnectionstatechange`, pc.iceConnectionState, ev);
        });

        pc.addEventListener(`icegatheringstatechange`, (ev) => {
            console.log(`icegatheringstatechange`, pc.iceGatheringState, ev);
        });

        pc.addEventListener(`negotiationneeded`, (ev) => {
            console.log(`negotiationneeded`, ev);
        });

        pc.addEventListener(`removestream`, (ev) => {
            console.log(`removestream`, ev);
        });

        pc.addEventListener(`datachannel`, (ev) => {
            let channel = ev.channel;
            channel.addEventListener(`open`, (ev) => {
                console.log(`idata channel open`);
            });

            channel.addEventListener(`message`, (ev) => {
                console.log(`idata channel message`, ev.data);
                appendToLog(`Them: `+ev.data);
            });

            channel.addEventListener(`close`, (ev) => {
                console.log(`idata channel closed`);
                doHangup();
            });
            console.log(`idatachannel`, ev);
        });

        pc.addEventListener(`close`, (ev) => {
            console.log(`close`, ev);
        });

        pc.addEventListener(`error`, (ev) => {
            console.log(`error`, ev);
        });

        pc.addEventListener(`message`, (ev) => {
            console.log(`message`, ev);
        });

        pc.addEventListener(`open`, (ev) => {
            console.log(`open`, ev);
        });

        pc.addEventListener(`tonechange`, (ev) => {
            console.log(`tonechange`, ev);
        });

        pc.addEventListener(`identiyresult`, (ev) => {
            console.log(`identiyresult`, ev);
        });

        pc.addEventListener(`idpassertionerror`, (ev) => {
            console.log(`idpassertionerror`, ev);
        });

        pc.addEventListener(`idpvalidationerror`, (ev) => {
            console.log(`idpvalidationerror`, ev);
        });

        pc.addEventListener(`peeridentity`, (ev) => {
            console.log(`peeridentity`, ev);
        });

        pc.addEventListener(`isolationchange`, (ev) => {
            console.log(`isolationchange`, ev);
        });

        pc.addEventListener(`addstream`, (ev) => {
            console.log(`addstream`, ev.stream);
            them.src = URL.createObjectURL(ev.stream);
            them.addEventListener(`loadedmetadata`, () => them.play());
        });
    },
    setupDataChannel = () => {
        channel = pc.createDataChannel(`test`, {reliable: true});

        channel.addEventListener(`open`, (ev) => {
            console.log(`data channel open`);
        });

        channel.addEventListener(`message`, (ev) => {
            console.log(`data channel message`, ev.data);
        });

        channel.addEventListener(`close`, (ev) => {
            console.log(`data channel closed`);
            doHangup();
        });
    },
    run = () => {
        input.value = ``;

        socket.on(`connect`, () => {
            console.log(`connected`);
            socket.on(`message`, (msg) => {
                if (`desc` == msg.type) rxDesc(msg.data);
                if (`candidate` == msg.type) rxCandidate(msg.data);
            });

            navigator.mediaDevices.getUserMedia({video: true})
                .then((s) => {
                    stream = s;

                    let objUrl = window.URL.createObjectURL(stream);
                    me.src = objUrl;
                    me.addEventListener(`loadedmetadata`, () => me.play());

                    setupPeerConnection();
                    setupDataChannel();

                    call.addEventListener(`click`, doCall),
                    answer.addEventListener(`click`, doAnswer);
                    hangup.addEventListener(`click`, doHangup);
                })
                .catch((e) => console.log(e));
        });
    };

run();
say.addEventListener(`click`, submitChat);
input.addEventListener(`keypress`, (ev) => {
    if (`Enter` == ev.key) submitChat();
});
