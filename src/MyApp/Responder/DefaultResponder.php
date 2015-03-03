<?php
namespace MyApp\Responder;

class DefaultResponse
{
    use \Adore\ResponderTrait;

    protected $data;

    public function setData($data)
    {
        $this->data = $data;
    }

    public function __invoke()
    {
        $this->_response->content->set($this->data);

    }
}