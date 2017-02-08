<?php
class AutoTree
{
    public function __get($prop)
    {
        if (!isset($this->$prop)) {
            $this->$prop = new self();
        }
        return $this->$prop;
    }
}

$a = new AutoTree();

$a->b->c->d->e->f->g = 'h';

echo $a->b->c->d->e->f->g;
