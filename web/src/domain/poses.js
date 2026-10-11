const POSES = {
  pose_contra: {
    pose_contra: [0, 0.1],
    pose_contra_attention: [0.1, 0.24],
    pose_contra_lookFeet: [0.24, 0.4],
    pose_contra_shift: [0.4, 0.52],
    pose_contra_bow: [0.52, 0.62],
    pose_contra_canCan: [0.62, 0.72],
    pose_contra_toStand: [0.72, 1],
  },
  pose_contra_attention: { pose_contra: [0, 1] },
  pose_contra_lookFeet: { pose_contra: [0, 1] },
  pose_contra_shift: { pose_contra: [0, 1] },
  pose_contra_bow: { pose_contra: [0, 1] },
  pose_contra_canCan: { pose_contra: [0, 1] },
  pose_contra_toStand: { pose_stand: [0, 1] },
  pose_stand: {
    pose_stand: [0, 0.1],
    pose_stand_lookAround: [0.1, 0.333],
    pose_stand_model: [0.333, 0.566],
    pose_stand_stretch: [0.566, 0.8],
    pose_stand_toContra: [0.8, 1],
  },
  pose_stand_lookAround: { pose_stand: [0, 1] },
  pose_stand_model: { pose_stand: [0, 1] },
  pose_stand_stretch: { pose_stand: [0, 1] },
  pose_stand_toContra: { pose_contra: [0, 1] },
};

const FIRST_POSE = 'pose_contra';

export function startPosing(buddy) {
  for (const name of Object.keys(POSES)) {
    const animation = buddy.animations.get(name);
    if (animation) animation.loop = false;
  }
  buddy.play(FIRST_POSE);
}

export function keepPosing(buddy) {
  if (buddy.step()) return;
  const next = POSES[buddy.animationName] ?? POSES[FIRST_POSE];
  const roll = Math.random();
  const pose = Object.keys(next).find(name => roll + 0.001 >= next[name][0] && roll - 0.001 <= next[name][1]) ?? FIRST_POSE;
  buddy.play(pose);
  buddy.step();
}
