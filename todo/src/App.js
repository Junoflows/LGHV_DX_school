// import logo from './logo.svg';
import './App.css';
import React from 'react'
import ToDo from "./ToDo";
import { call } from './service/ApiService';

import {Paper, List, Container} from '@material-ui/core'

import AddToDo from './AddToDo';

class App extends React.Component{
  constructor(props){
    super(props);
    // 여러 개의 객체를 생성해서 state에 item 이라는 이름으로 저장 
    this.state = {items : []};
  }
  // 컴포넌트가 메모리 할당을 한 후 출력하기 전에 호출되는 메서드
  componentDidMount(){
    //데이터를 가져오는 API 요청을 수행
    call('/todo', "GET", null)
    .then((response) => this.setState({items:response.list}))
  }


  // 데이터 추가를 위한 함수
  // Item 1개를 받아서 items 에 추가하는 함수
  add = (item) => {
    item.userid = 'junho';
    call('/todo', "POST", item)
    .then((response) => this.setState({items : response.list}))
  }

  // 데이터를 삭제하는 함수
  delete = (item) => {
    item.userid = 'junho';
    call('/todo', "DELETE", item)
    .then((response) => this.setState({items : response.list}))
  }

  // 데이터를 수정하는 함수
  update = (item) => {
    item.userid = 'junho'
    call('/todo', "PUT", item)
    .then((response) => this.setState({items : response.list}))
  }

  render(){
    // map : 데이터의 모임을 순회하면서 함수를 적용해 함수의 리턴 값을 가지고
    // 데이터의 모임을 만들어주는 함수
    // 데이터 변환에 활용
    var todoItems = this.state.items.length > 0 && (
      <Paper style={{margin : 16}}>
        <List> 
          {this.state.items.map((item, idx) => (
            <ToDo item = {item} key = {item.id} delete = {this.delete}
            update = {this.update}/>
          ))}
        </List>
      </Paper>
    )

    return(
      <div className='App'>
        <Container maxWidth = 'md'>
          <AddToDo add = {this.add}/>
          {todoItems} 
        </Container>
      </div>
    )
  }
}

export default App;