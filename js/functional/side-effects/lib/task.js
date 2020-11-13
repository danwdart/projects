import {compose} from './combinators';
import {Left, Right} from './either';

export const Task = fork => ({
    fork,
    map: f => Task(
        (reject, resolve) =>
            fork(
                reject,
                compose(resolve)(f)
            )
    ),
    join: () => Task(
        (reject, resolve) =>
            fork(
                reject,
                task => task.fork(reject, resolve)
            )
    ), 
    flatMap: f => Task((reject, resolve) =>
        fork(
            reject,
            x => f(x).fork(reject, resolve)
        )
    )
});

//eslint-disable-next-line cleanjs/no-rest-parameters
export const Taskify = cb => (...args) =>
    Task(
        (reject, resolve) => cb(
            ...args,
            (error, result) => error ? reject(Left(error)) : resolve(Right(result))
        )
    );

export const TaskOf = x => Task((_, resolve) => resolve(x));
export const TaskRejected = x => Task(reject => reject(x));

export const eitherToTask = e => e.fold(TaskRejected, TaskOf);