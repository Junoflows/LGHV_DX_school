function Sample(props){
    // 자바스크립트의 구조 분해 할당
    // = 오른쪽에 객체를 설정하고
    // 왼쪽에 {}안에 변수르 설정하면 
    // 변수 이름과 동일한 객체의 속성이 분해돼서 대입됨
    const {album, children} = props;   

    return (<div>두 번째 차는 {props.album} 
    태그 안의 내용은 {props.children}</div>)
}
export default Sample;